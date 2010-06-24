require 'prawn/style_helper'

module StyleConverter
  class Prawn       
    attr_accessor :css_style, :prawn_style

    def initialize(css_style, convert = true, &block)
      set_css_style css_style
      to_prawn_style if convert  
      in_context(&block) if block      
    end      

    def self.parse(css_style, &block)
      prawn_style = new css_style   
      in_context(&block) if block      
    end

    def set_css_style css_style
      case css_style
      when StyleConverter::Css
        @css_style = css_style
      when String
        @css_style = StyleConverter::Css.new css_style
      else       
        raise ArgumentError, "StyleConverter::Prawn must be initialized with either a css_style String or a StyleConverter::Css instance"
      end
    end

    def in_context(context_name = nil, &block)
      ctx = get_context(context_name)
      if block
        block.arity < 1 ? ctx.instance_eval(&block) : block.call(ctx)      
      end      
    end

    def get_context(context_name)
      if context_name
        send context_name 
      else
        self
      end
    end


    def to_prawn_style
      @prawn_style ||= {}        

      # handle mappings
      css_to_prawn_style_mappings.each_pair do |css_key, prawn_key|
        value = send css_key
        @prawn_style[prawn_key] = value if value
      end      

      # 1-1 mappings where css style name is same as in prawn
      style_keys.each do |key|
        value = send key
        @prawn_style[key] = value if value
      end

      @prawn_style[:styles] = styles if styles
      @prawn_style[:underlays] = true
    end

    protected   

    include StyleHelper
  end
end
