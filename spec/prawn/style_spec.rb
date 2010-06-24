require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module CssStyleHelper   
  def selector(selector_text)
    CssParserMaster::Selector.new('pdf_rule', selector_text, 99999)
  end  
  
  def create_css_style css_declarations
    selector_text = "#{css_declarations}" 
    selector = selector(selector_text, 99999)
    StyleConverter::Css.parse(selector.declarations)
  end
end

module PrawnStyleHelper
  def assert_prawn_style prawn_style
    prawn_style[:size].should == 10
    prawn_style[:font_family].should == 'helvetica'
    prawn_style[:styles].should == []
    prawn_style[:color].should == 'ff0000'
    prawn_style[:background_color].should == '0000ff'
  end
  
end

describe StyleConverter::Prawn do
  let(:css)  { 'color: red; font-size: 10; background_color: #0000ff; font_family: helvetica'}
  
  include CssStyleHelper
  include PrawnStyleHelper

  before(:each) do
    @css_style_converter = create_css_style_converter(css)
  end

  describe 'self#parse' do       
    it "should create a new prawn style converter from a css style converter" do
      prawn_styler = StyleConverter::Prawn.parse(@css_style_converter)
      assert_prawn_style(prawn_style)
      prawn_styler.css_style.should == @css_style_converter
    end

    it "should create a new prawn style converter from a css style declarations string" do
      prawn_styler = StyleConverter::Prawn.parse(css)
      assert_prawn_style(prawn_style)
      prawn_styler.css_style.should be_a_kind_of StyleConverter::Css
    end
  end
     
  describe '#new' do       
    it "should create a new prawn style" do    
      prawn_style = StyleConverter::Prawn.new(@css_style).prawn_style
      assert_prawn_style prawn_style
    end
  end  
  
  describe 'methods' do                                            
           
    describe '#fontstyle' do
      FONT_STYLE = 'italic'
      FONT_WEIGHT = 'bold'
      @font_style_css = "font-weight=#{FONT_WEIGHT}, font-style=#{FONT_STYLE}"

      context @font_style_css do
        it "should set prawn style to [:#{FONT_STYLE}, :#{FONT_WEIGHT}]" do    
          
          create_prawn_style_converter(@font_style_css) do                                   
            in_context :prawn_style do                    
              # check that no conversion has yet been performed
              [:styles].should == []            
            end

            # perform conversion
            send :font_style

            in_context :prawn_style do
              # assert conversion result
              [:styles].should include :"#{FONT_STYLE}"
              [:styles].should include :"#{FONT_WEIGHT}"
            end
          end
        end
      end
    end

    describe '#margin' do
      @margin = '5 px'
      @margin_left = '6 px'
      @margin_top = '7 px'
      @margin_right = '8 px'
      @margin_bottom = '9 px'
      @margin_css = "margin: #{@margin}"          

      context @margin_css do            
        it "should set prawn margin style to {:margin => #{@margin}}" do              

          create_prawn_style_converter(@margin_css) do                                   
            in_context :prawn_style do          
              # check that no conversion has yet been performed
              prawn_style[:margin].should == nil || {}

              # perform conversion
              send :margin

              # assert conversion result
              prawn_style[:margin].should == 5
            end
          end
        end
      end

      @margin_css = "margin-left=#{@margin_left}, margin-top=#{@margin_top}"
      context @margin_css do            
        it "should set prawn margin style to {:margin => {:left => #{@margin_left}, :top => #{@margin_top}}}" do                  

          create_prawn_style_converter(@margin_css) do                      
            # check that no conversion has yet been performed
            prawn_style[:margin].should == nil || {}

            # perform conversion
            send :margin

            in_context :prawn_style do
              # assert conversion result
              [:margin][:margin_left].should == 6
              [:margin][:margin_top].should == 7
            end
          end
        end
      end 
      @margin_css = "margin-right=#{@margin_right}, margin-bottom=#{@margin_bottom}"
      context @margin_css
        it "should set prawn margin style to {:margin => {:right => #{@margin_right}, :bottom => #{@margin_bottom}}}" do        

          create_prawn_style_converter(@margin_css) do                      
            # check that no conversion has yet been performed
            prawn_style[:margin].should == nil || {}

            # perform conversion
            send :margin

            in_context :prawn_style do
              # assert conversion result
              [:margin][:margin_right].should == 8
              [:margin][:margin_bottom].should == 9
            end
          end
        end
      end
    end
  end  
end
