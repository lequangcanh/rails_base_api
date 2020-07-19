class HashSerializer
  attr_reader :object, :root

  def initialize object, args = {}
    @object = object
    @root = args[:root]
  end

  def to_hash
    root ? {root_key => object.to_h} : object.to_h
  end

  private
  def root_key
    return :data if root == true
    root.to_sym if root.is_a?(String) || root.is_a?(Symbol)
  end
end
