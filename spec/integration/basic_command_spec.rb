RSpec.describe "Basic command" do
  context "commands" do
    it "calls basic command" do
      output = `foo version`
      expect(output).to match("v1.0.0")
    end

    it "calls basic command with alias" do
      output = `foo -v`
      expect(output).to match("v1.0.0")

      output = `foo --version`
      expect(output).to match("v1.0.0")
    end

    it "fails for unknown command" do
      result = system("foo unknown")
      expect(result).to be(false)
    end

    it "prints in console the description" do
      output = `foo`

      expect(output).to match("foo hello")
      expect(output).to match("foo version")
      expect(output).to match("foo generate")
    end
  end

  context "subcommands" do
    it "calls subcommand" do
      output = `foo generate model`
      expect(output).to match("generated model")
    end

    it "calls subcommand with alias" do
      output = `foo generate --help`
      expect(output).to match("help for generate")
    end

    it "fails for unknown subcommand" do
      result = system("foo generate unknown")
      expect(result).to be(false)
    end

    it "prints in console the description" do
      output = `foo generate`

      expect(output).to match("foo generate --help")
      expect(output).to match("foo generate model")
      expect(output).to match("foo generate action")
      expect(output).to match("foo generate webpack")
    end
  end

  context "third-party gems" do
    it "allows to override basic commands" do
      output = `foo hello`
      expect(output).to match("world")
    end

    it "allows to add a subcommand" do
      output = `foo generate webpack`
      expect(output).to match("generated configuration")
    end

    it "allows to override a subcommand" do
      output = `foo generate action`
      expect(output).to match("generated action")
    end
  end
end
