class String

  def classify(prefix="")
    Kernel.const_get(prefix.to_s + "::" + self.split('_').collect(&:capitalize).join)
  end

end
