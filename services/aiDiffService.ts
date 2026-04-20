import { GoogleGenerativeAI } from "@google/generative-ai";

export const aiDiffService = {
    async generateDiffSummary(oldText: string, newText: string): Promise<string | null> {
        const apiKey = localStorage.getItem('GOOGLE_AI_API_KEY');
        if (!apiKey) return null; // Logic is: If no key, skip AI summary, just save raw edit.

        const genAI = new GoogleGenerativeAI(apiKey);
        const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

        const prompt = `
            Compare the following two versions of a note in Vietnamese and describe what changed.
            Be concise. Start with "Sửa đổi: " (Edited:). 
            If valid changes found, describe semantic changes (e.g. changed size 5 to 10).
            If no meaningful change, return "No change".
            
            Old: "${oldText}"
            New: "${newText}"
        `;

        try {
            const result = await model.generateContent(prompt);
            const response = result.response;
            const text = response.text().trim();

            if (text.toLowerCase().includes('no change')) return null;
            return text;
        } catch (error) {
            console.error("AI Diff failed:", error);
            return null; // Fail gracefully
        }
    }
};
