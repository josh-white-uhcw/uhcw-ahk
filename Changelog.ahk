GetChangelogData() {
    return [
        {
            Version: "v1.3.6",
            Changes: [
                { type: "added", text: "✅ Added about page that will show changelogs and other info" },
                { type: "added", text: "✅ Added categories for scripts in listviews for easier finding"},
                { type: "added", text: "✅ Added Triage script for automating triage requests"},
    
                { type: "changed", text: "🔃 Replaced the changelogs in the main GUI with a announcements block. Will make it functional at some point." }
            ]
        },
        {
            Version: "< v1.3.5",
            Changes: [
                { type: "", text: "All old logs are visible on github." }
            ]
        }
    ]
}