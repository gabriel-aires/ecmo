class Host

  def self.inventory(node)

    keys = [
      :memory,
      :hostname,
      :domain,
      :fqdn,
      :platform,
      :platform_version,
      :filesystem,
      :cpu,
      :virtualization,
      :kernel,
      :block_device,
      :user,
      :group,
    ]

    node_properties = {}

    keys.each do |key|
      node_properties[key] = node[key]
    end

    node_properties

  end

end
