require 'rqrcode'
require 'tmpdir'

module Qr
  class Generator < Jekyll::Generator
    def generate(site)
      site.collections["pages"].docs.each do |page|
        if page.data["target"]
          asset_name = page.basename_without_ext + ".png"
          file_path = File.join(Dir.tmpdir, asset_name)
          data = "https://mmm.camp#{page.url}"
          qr_code = RQRCode::QRCode.new(data)
          png = qr_code.as_png(
            bit_depth: 1,
            border_modules: 1,
            color_mode: ChunkyPNG::COLOR_GRAYSCALE,
            color: "black",
            fill: "white",
            module_px_size: 30,
          )
          IO.binwrite(file_path, png.to_s)
          static_file = Jekyll::StaticFile.new(site, Dir.tmpdir, "", asset_name)
          site.static_files << static_file

          puts "#{data} -> #{asset_name}"         
        end
      end
    end
  end
end