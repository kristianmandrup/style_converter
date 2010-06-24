module StyleConverter    
  class Css 
    attr_accessor :font_style, :font_weight, :font_size, :font_family
    attr_accessor :color, :background_color
    attr_accessor :border_style, :border_width       

    protected

    def self.directions
      [:left, :right, :top, :bottom]
    end

    public

    # generate accessors for all variants of margin, margin_left, padding etc
    [:margin, :padding].each do |name|   
      attr_accessor name
      directions.each{|dir| attr_accessor :"#{name}_#{dir}" }
    end      
 
    def initialize        
      # set defaults        
      @font_size = 10       
      @font_family = "Helvetica"
      @color = "000000"
    end

    def self.parse(style_declarations, &block)
      return if !style_declarations
      new.parse_declarations(style_declarations)
      
      in_context(&block) if block
    end
    
    def self.in_context(&block)
      if block
        block.arity < 1 ? self.instance_eval(&block) : block.call(self)      
      end      
    end
    
    # sets Prawn color by translating to Prawn variant, fx 'ff0000'
    def color=(col)
      translate_color(col)
    end

    # sets Prawn color by translating to Prawn variant, fx 'ff0000'
    def background_color=(col)
      translate_color(col)
    end

    # sets Prawn color by translating to Prawn variant, fx 'ff0000'
    def font_size
      css_style.font_size.to_s.to_i        
    end

    protected

    def translate_color(col)
      Colorist::ColorNames.color(col.to_s, :lower, :simple)        
    end                        
    
    # iterate array with hashes of style_declaration
    def parse_declarations(style_declarations)
      style_declarations.each do |decl|
        parse_style_declaration(decl[1])
      end
      self
    end    

    def parse_style_declaration(style_declaration)
      method = style_declaration.property.underscore
      value = style_declaration.value.to_sym
      send :"#{method}=", value
    end        
  end
end