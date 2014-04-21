class TableNameToClass
  @@conversion_hash = nil

  def self.convert(name, force_update = nil)
    init_hash unless @@conversion_hash || force_update
    @@conversion_hash[name.to_s]
  end

  def self.debug
    return @@conversion_hash
  end

  private

  def self.init_hash
    # Expanded from idea posted here: http://stackoverflow.com/a/6150228

    # Recursively require all models
    Dir.glob(Rails.root.join('app','models','**','*').to_s).each do |f|
      begin
        require f if File.file?(f) && f =~ /\.rb$/
      rescue IdentityCache::AlreadyIncludedError
      end
    end

    @@conversion_hash = Hash[
      ActiveRecord::Base.descendants.map {|c| [c.table_name, c]}
    ]
  end
end
