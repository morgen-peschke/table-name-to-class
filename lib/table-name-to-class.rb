class TableNameToClass
  @@conversion_hash = nil

  ##
  # Convert a table name into a class constant (or nil if no constant for that
  # table)
  # ---
  # Expects:
  #   name (object like string):: Name of database table, this can be anything
  #                               that returns a valid table name when hit with
  #                               to_s
  #   force_update (boolean):: Should the table/class correspondence be updated?
  #                            Any non-nil value triggers a reload.
  #
  # Returns:
  #   nil if the lookup fails, the constant for the class associated with the
  #   table otherwise.
  def self.convert(name, force_update = nil)
    init_hash unless @@conversion_hash || force_update
    @@conversion_hash[name.to_s]
  end

  ##
  # Debug helper
  # ---
  # Returns the hash of table name and class constant pairs
  def self.debug
    return @@conversion_hash
  end

  private

  ## :doc:
  # Loads the correspondence cache
  # ----
  # Recursively visits every .rb file in app/models and requires them all. This
  # is required to avoid failures when trying to convert the name of a table
  # who's model has not yet been loaded.
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
