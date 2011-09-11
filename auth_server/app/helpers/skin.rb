AuthServer.helpers do
  def skin_for (account, options={})
    return unless account.is_a?(Account)

    url = if File.exists?(File.join('public', 'images', 'skin', "#{account.nick}.png"))
            asset_path(:images, "skin/#{account.nick}.png")
          else
            asset_path(:images, "default_skin.png")
          end

    image_tag(url, options)
  end
end
