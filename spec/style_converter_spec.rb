require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe StyleConverter do

     
  describe "#new" do       
    it "should create a new css style" do    
      styler.font_size.should == 10
      styler.font_family.should be_a_kind_of String
      styler.color.should be_a_kind_of String
    end
  end

  describe "StyleMapper#parse" do        
    it "should parse a css style" do 
      styler = parsed_style
      styler.should be_a_kind_of Howrah::StyleMapper   
      styler.color.should == "ff0000"
      styler.font_size.should == 10
    end
  end

  describe "#to_pdf_style" do
    it "should parse a map style" do 
      styler = parsed_style
      pdf_style = styler.to_pdf_style # do it

      pdf_style.should be_a_kind_of Hash   
      puts pdf_style
      pdf_style[:size].should == 10
      pdf_style[:color].should == "ff0000"
      pdf_style[:font].should == 'Helvetica' 
      pdf_style[:fill_color].should == "0000ff"
    end
  end

  describe "#to_pdf_style" do
    it "should parse a css style" do 
      styler = parsed_style
      pdf_style = styler.to_pdf_style # do it
    end
  end
end
