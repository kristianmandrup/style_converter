require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module StyleHelper
  def selector(selector_text)
    CssParserMaster::Selector.new('pdf_rule', selector_text, 99999)        
  end

  def create_css_style css_declarations, &block
    selector_text = "#{css_declarations}" 
    selector = selector(selector_text, 99999)        
    StyleConverter::Css.parse(selector.declarations, &block)
  end
end

describe StyleConverter::Css do   
  let(:css_style)         { StyleConverter::Css.new }  
  let(:css_declarations)  { 'color: red; font-size: 10; background_color: #0000ff; font_family: helvetica'}
  
  include StyleHelper

  describe "self#parse" do       
    it "should create a new css style" do    
      create_css_style(css_declarations) do
        font_size.should == 10
        font_family.should == 'helvetica'
        color.should == 'red'
        background_color.should == '#0000ff'
      end
    end
  end
     
  describe "#new" do       
    it "should create a new css style" do    
      css_style.in_context do
        font_size.should == 10
        font_family.should be_a_kind_of String
        color.should be_a_kind_of String
      end
    end
  end  
  
  describe "#color=" do       
    RED_COLOR = '#ff0000'
    BLUE_COLOR = 'blue'
    
    it "should set color by hex code #{RED_COLOR}" do    
      css_style.in_context do
        color = RED_COLOR
        color.should == RED_COLOR      
      end
    end

    it "should set color by name #{BLUE_COLOR}" do    
      css_style.in_context do
        color = BLUE_COLOR
        color.should == BLUE_COLOR      
      end
    end
  end  

  describe "#background_color=" do       
    RED_COLOR = '#ff0000'
    BLUE_COLOR = 'blue'
    
    it "should set background_color by hex code #{RED_COLOR}" do    
      css_style.in_context do
        background_color = RED_COLOR
        background_color.should == RED_COLOR      
      end
    end

    it "should set background_color by name #{BLUE_COLOR}" do    
      css_style.in_context do
        background_color = BLUE_COLOR
        background_color.should == BLUE_COLOR      
      end
    end
  end  

  describe "#font_size=" do       
    FONT_SIZE = 12
    
    it "should set font_size to #{FONT_SIZE}" do    
      css_style.in_context do
        font_size = FONT_SIZE
        font_size.should == FONT_SIZE
      end
    end
  end  
end
