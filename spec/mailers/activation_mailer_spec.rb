require "rails_helper"

RSpec.describe ActivationMailer, type: :mailer do
  describe "activation" do
    let(:mail) { ActivationMailer.activation }

    it "renders the headers" do
      expect(mail.subject).to eq("Activation")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "password_reset" do
    let(:mail) { ActivationMailer.password_reset }

    it "renders the headers" do
      expect(mail.subject).to eq("Password reset")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
