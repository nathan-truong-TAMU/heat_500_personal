require "google/cloud/text_to_speech"

ENV['GOOGLE_APPLICATION_CREDENTIALS_JSON'] = '{
  "type": "service_account",
  "project_id": "text-to-speech-416204",
  "private_key_id": "0906868973edf9fe6c4f316ed208fa68d4c65c63",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDSUdMUnKfMj8Ks\nYsSoQhg+d6Qa6NVaa83/X/oqHx+aMoBui8yAtldireAQnsNSL7ejzALDr5QzC89X\nIG0rn6QHg7Aht7RwQDQHRqVe+qop58Eto96BqKCxlHd1B5+/gugytnSKYXdHHjar\nnsNU10jEMWgfyNnqom2SkEqz5b2svTl1kAD1UZk3zGjRJcvILmSFV+tTAWDMkY2j\n+JC7OrPA3aq2tzPGr5eK9h5/2ULYELe+uYF5iwUPL25LrXi+ViHLipql8xsfQ5LL\nNvsZNDNZk0WvSP5HqJX1KkLTLV8XoXtAa3ftQqS5e0PddqtN9bq0LzTtcXd8uILV\nXI2whOOFAgMBAAECggEAKXq4R9QmluZSdVesY+fXKrjDXYhGjcT9tWw7JSQKwklM\nAaFiNY9guCZFLtn0+ShOjkgt0mS2NIQTgiIzzbr4KYA8FEZMGKhc6oNxGYST21xp\nAcSUHVvBx4wZrDPS+n0JqPjJjsIuuVC45QuUiA7Ge+UnnT8qVUdwF0wMY6L/j8nN\nWslS0r8OfoMHqAZ7o344YxcMvSAph3GhvXHKjmVeeZQUyKOQ2xYNsJ8ZEL4oc+Cd\nkL1vRqjNY4CuHqs/3I5ginEdf51+eZsh6ivvh6Y4+Q6BMhBV5LrmJWennShbTf2O\nXXoaIhrrCBGYTlk6yIsKGjtLuGci5BYBgkN0gji3AQKBgQD02VpEdHJOSogty6fp\n02YDM5R4auOoOjXkAb0tJ5GpZGml8Ji/88X+KOgT7sgoGeWedpCUMkkjKLm6WyV/\nhXq+KP5D22GggaPQwlhwcbq5OzgPh0Z+Vh2I8IcJ/7tm5I7XkKa72m0BuNqHoPi0\ntgDuae56YadKyr3WaXdNBJ0bAQKBgQDb5eZ4Q8XDP4LiVUsG6Png0hB1bvfxS2d1\nYisRk1CwBrD3DH5Lcik53TvYJzVL4Z15x8+PnjHxQ4hc4685Tc6lnjAQKvC+tl6o\n1xCMWxjKaY0LPCMfFcIJCTd9oupoIyGvYGVUvFCqRsszxxcSiiejOzyf88o6aqEh\n/t9/nLHchQKBgQCleg/rm9d02iJW8QC2osya9U0uZO8fTtgFFLfJwKhNFzPflk9l\ny1bQgsz2S7ayg24QPolP3vxW6rs7G0aofImL4yCUs7uzQmp4OCCVPge4EDG/LOmT\nkJe9aPGa7F63F1kCjxxgcSqis0/dwgjT+P2AI8+snjr17TeHpRef0bJsAQKBgE91\n+hxHUTVGxAMJkz0B/xmwjuYAnXQCLXaLbMjDFQsmv9fmGdUlgaQ5P6DSOj4bXw5c\nl7JsFdv67VGzrOPmK+BJE1EkUy53NCmK3Z36ZTDvh1oh9wcKk700KWsq7c2HtGpt\nSPCfw/5j6pXhQYMfjUc85qFeNRt64JMqSJUSiGsJAoGBAJ0Lc8YQaFoUT9L4GoAx\nOvET1410hBRjpuGmVqVrjBtxhcPpfP1xtsn1lYxAQwbI9VZuKQkgBdJckUuX2qXn\nEKbTShvlp2U/LH2w73/WURArxWXdB4s2rHKm4wKeKLNbEPFjfcbOILKRIOEwQVuA\nM7fZ8plXsu12VI3kl64rOXjv\n-----END PRIVATE KEY-----\n",
  "client_email": "text-to-speech@text-to-speech-416204.iam.gserviceaccount.com",
  "client_id": "105873689906479863244",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/text-to-speech%40text-to-speech-416204.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}'

Google::Cloud::TextToSpeech.configure do |config|
  config.credentials = JSON.parse(ENV['GOOGLE_APPLICATION_CREDENTIALS_JSON'])
end
