class JsonWebToken
  class << self
    def encode(payload, exp = 2.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end

    def decode(token)
      body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      HashWithIndifferentAccess.new body

    rescue JWT::ExpiredSignature, JWT::VerificationError => e
      Rails.logger.warn "---JSON WEB TOKEN HAS EXPIRED--- #{e.message}"
      false
    rescue JWT::DecodeError, JWT::VerificationError => e
      Rails.logger.warn "---JSON WEB TOKEN IS NOT VALID--- #{e.message}"
      false
    end
  end
end
