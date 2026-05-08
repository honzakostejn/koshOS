{ ... }: {
  services.whisp-away = {
    enable = true;
    defaultModel = "large-v3";         # Default model (changes apply immediately)
    defaultBackend = "faster-whisper";   # Backend selection (changes apply immediately)
    accelerationType = "openvino";      # or "cuda", "openvino", "cpu" - requires rebuild
    useClipboard = false;             # Output mode (changes apply immediately)
    useCrane = false;                 # Enable if you want faster rebuilds when developing
  };
}