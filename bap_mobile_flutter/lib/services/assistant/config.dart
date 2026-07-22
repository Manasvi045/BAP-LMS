// lib/services/assistant/config.dart — single source of truth for the OpenRouter integration.
// 1:1 port of src/lib/assistant/config.ts.

class AssistantConfig {
  /// OpenRouter's OpenAI-compatible chat-completions endpoint.
  static const String endpoint = 'https://openrouter.ai/api/v1/chat/completions';

  /// Default model. Can be swapped at runtime via the model override (future).
  static const String model = 'nvidia/nemotron-3-super-120b-a12b:free';

  /// Headers OpenRouter recommends for app attribution.
  static const Map<String, String> appHeaders = <String, String>{
    'HTTP-Referer': 'https://bap.app',
    'X-Title': 'BAP Study Assistant',
  };

  /// System-prompt size budget. Caps at 2M chars (the model has ~500K TOKEN
  /// context). Reference data is uncapped.
  static const int maxContextChars = 2000000;

  static const int introBudgetChars = 2500;
  static const int catalogBudgetChars = 5000;
  static const int referenceBudgetChars = 1990000;
}

/// System-prompt identity — who the model is, what the app is, how to behave.
const String systemPromptIdentity =
    'You are the BAP Study Assistant — a tutor for the Business Acceleration Platform, '
    'a medical-device learning app for Meril\'s sales and clinical teams.\n\n'
    'Answer the user\'s question directly. Use BAP product, clinical, and competitor data when '
    'it\'s relevant; use your own medical knowledge for general questions. Don\'t preface '
    'answers with "in the BAP app" or "the BAP catalog says" — just answer.\n\n'
    'Be concise (2-5 sentences unless the user asks for more detail). Use product, topic, and '
    'competitor names EXACTLY as they appear in the reference data below — typos and casual '
    'phrasing erode trust. If a name isn\'t in the reference data, say so.';