require 'erb'

module Sprite
  module Styles
    # renders css rules from template
    class TemplatedCssGenerator
      def initialize(builder)
        @builder = builder
      end

      def write(path, sprite_files)
        # write styles to disk
        File.open(File.join(Sprite.root, path), 'w') do |f|
          sprite_files.each do |sprite_file|
            @builder.images.each do |image|
              if "#{image['name']}.#{image['format']}" == sprite_file[0]
                erb_path = @builder.send :style_template_source_path, image
                erb_template = ERB.new(File.read(erb_path))
                sprites = sprite_file[1]
                sprites.each do |sprite|
                  name = sprite[:name]
                  width = sprite[:width]
                  height = sprite[:height]
                  left = sprite[:x]
                  top = sprite[:y]
                  image_path = ImageWriter.new(@builder.config).image_output_path(image['name'], image['format'])
                  f.puts erb_template.result(binding)
                end
              end
            end
          end
        end
      end

      def extension
        "css"
      end
    end
  end
end