module StyleConverter
  class Prawn       
    module StyleHelper
      # TODO: underline, strikethrough ?
      # Assembles a Prawn font_style from font_weight and font_style of css_style 
      # :bold_italic
      # :bold
      # :italic
      def font_style             
        style = css_style.font_weight == :bold ? "#{css_style.font_weight}_" : "" 
        style += "#{css_style.font_style}" if css_style.font_style == :italic
        style.empty? ? nil : style.to_sym               
      end

      # creates Prawn margin style hash from css_style margins    
      def margin        
        margins = {}        
        CssStyle.directions.each do |dir| 
          value = css_style.send :"margin_#{dir}"
          margins[dir] = value if value
        end    
        return nil if margins == {} 
        margins
      end

      # creates Prawn padding style hash from css_style paddings    
      def padding
        paddings = {}
        CssStyle.directions.each do |dir| 
          value = css_style.send :"padding_#{dir}"
          paddings[dir] = value if value
        end
        return nil if paddings == {}           
        paddings
      end

      def styles
        _styles ||= []        
        _styles << css_style.font_weight if css_style.font_weight
        _styles << css_style.font_style if css_style.font_style
      end  

      def css_to_prawn_style_mappings
        {
          :font_size => :size,
          :font_family => :font,
          :background_color => :fill_color
        }
      end

      def style_keys
        [:color, :border_style, :border_width, :margin, :padding]
      end
    end
  end
end