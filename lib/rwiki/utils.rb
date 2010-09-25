module Rwiki::Utils

  def move_node(node_name, dest_folder_name)
    new_node_name = File.join(dest_folder_name, File.basename(node_name))
    return false if File.exists?(new_node_name)

    FileUtils.mv(node_name, dest_folder_name)
    return true, new_node_name
  end

end
