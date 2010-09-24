module Rwiki::Utils
  include FileUtils

  PAGE_FILE_EXT = '.txt'
  CODE_REGEXP = /\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m.freeze

  def rename_node(old_node_name, new_base_name)
    new_name = File.join(File.dirname(old_node_name), new_base_name)
      
    return false if File.exists?(new_name)
    mv(old_node_name, new_name)

    return true, new_name
  end

  def move_node(node_name, dest_folder_name)
    new_node_name = File.join(dest_folder_name, File.basename(node_name))
    return false if File.exists?(new_node_name)

    mv(node_name, dest_folder_name)
    return true, new_node_name
  end

  def delete_node(node_name)
    return false unless File.exists?(node_name)
    rm_rf(File.join(node_name))
    return true
  end

end
