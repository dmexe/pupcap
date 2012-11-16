class Pupcap::LsbRelease
  def initialize(cap)
    @cap = cap
  end

  def name
    @name ||= get("i")
  end

  def codename
    @release ||= get("c")
  end

  private
    def get(code)
      code = @cap.capture("lsb_release -#{code}")
      code.split(":")[1].to_s.strip
    end
end
