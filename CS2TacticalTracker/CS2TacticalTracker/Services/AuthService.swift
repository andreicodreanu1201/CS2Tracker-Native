import Foundation
import Supabase
import SwiftUI
internal import Combine

class AuthService: ObservableObject {
    static let shared = AuthService()
    
    // Clientul Supabase va fi inițializat în init()
    var client: SupabaseClient
    
    // Statusul utilizatorului și rolul (Admin/User)
    @Published var currentUserRole: String = "user"
    @Published var sessionUser: User?

    init() {
        // 1. Încercăm să citim datele din Secrets.plist
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let urlString = dict["SUPABASE_URL"] as? String,
              let keyString = dict["SUPABASE_KEY"] as? String,
              let url = URL(string: urlString) else {
            // Dacă lipsește fișierul sau cheile, aplicația se oprește cu un mesaj clar
            fatalError("CRITICAL ERROR: Secrets.plist nu a fost găsit sau nu conține cheile corecte!")
        }
        
        // 2. Inițializăm clientul cu datele securizate
        self.client = SupabaseClient(supabaseURL: url, supabaseKey: keyString)
    }
    
    // MARK: - Autentificare (Login)
    func signIn(email: String, pass: String) async throws -> String {
        let response = try await client.auth.signIn(email: email, password: pass)
        
        // După login, preluăm profilul pentru a vedea rolul (User/Admin)
        let userId = response.user.id
        
        struct Profile: Codable {
            let role: String
        }
        
        let profile: Profile = try await client
            .from("profiles")
            .select("role")
            .eq("id", value: userId)
            .single()
            .execute()
            .value
        
        await MainActor.run {
            self.sessionUser = response.user
            self.currentUserRole = profile.role
        }
        
        return profile.role
    }
    
    // MARK: - Înregistrare (Register)
    func signUp(email: String, pass: String, fullName: String) async throws {
        let response = try await client.auth.signUp(email: email, password: pass)
        
        // Creăm profilul în tabelul 'profiles' imediat după înregistrare
        let profileData: [String: String] = [
            "id": response.user.id.uuidString,
            "full_name": fullName,
            "role": "user" // Default este întotdeauna user
        ]
        
        try await client
            .from("profiles")
            .insert(profileData)
            .execute()
    }
    
    // MARK: - Deconectare
    func signOut() async throws {
        try await client.auth.signOut()
        await MainActor.run {
            self.sessionUser = nil
            self.currentUserRole = "user"
        }
    }
}
