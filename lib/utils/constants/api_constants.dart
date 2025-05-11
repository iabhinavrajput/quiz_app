class ApiConstants {
  static const baseUrl = 'https://api.groq.com/openai/v1/chat/completions';

  static const headers = {
    'Authorization': 'Bearer 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',
    'Content-Type': 'application/json',
  };

  static const requestBody = {
    "model": "llama3-8b-8192",
    "messages": [
      {
        "role": "user",
        "content":
            "Generate 5 general knowledge multiple-choice questions. Respond only with valid JSON in this format: [{\"question\": \"<text>\", \"options\": [\"A. <option>\", \"B. <option>\", \"C. <option>\", \"D. <option>\"], \"answer\": \"<correct option label, e.g. A. <option>\"}]. Do not include explanations or extra text.",
      },
    ],
  };
}
