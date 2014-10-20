
class SandboxEmailInterceptor
  def self.delivering_email(message)
    message.to = ['sample@example.com']
  end
end
