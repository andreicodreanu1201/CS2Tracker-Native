import Foundation
import Supabase
import SwiftUI
internal import Combine

class AuthService: ObservableObject {
    static let shared = AuthService()
    var client: SupabaseClient
    
    @Published var sessionUser: User?

    init() {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let urlString = dict["SUPABASE_URL"] as? String,
              let keyString = dict["SUPABASE_KEY"] as? String,
              let url = URL(string: urlString) else {
            fatalError("CRITICAL ERROR: Secrets.plist missing!")
        }
        self.client = SupabaseClient(supabaseURL: url, supabaseKey: keyString)
    }
    
    // LOGIN SIMPLIFICAT: Returnează doar succes/eroare
    func signIn(email: String, pass: String) async throws {
        let response = try await client.auth.signIn(email: email, password: pass)
        await MainActor.run {
            self.sessionUser = response.user
        }
    }
    
    func signUp(email: String, pass: String, fullName: String) async throws {
        let response = try await client.auth.signUp(email: email, password: pass)
        
        let profileData: [String: String] = [
            "id": response.user.id.uuidString,
            "full_name": fullName,
            "deployment_region": "Europe - Core Sector"
        ]
        
        try await client.from("profiles").insert(profileData).execute()
    }

    func signOut() async throws {
        try await client.auth.signOut()
        await MainActor.run { self.sessionUser = nil }
    }
}
