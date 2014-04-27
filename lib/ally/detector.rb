module Ally
  class Detector
    attr_accessor :inquiry, :data_detected, :settings

    def initialize(inquiry = nil)
      inquiry(inquiry)
      @data_detected = false
      @settings = nil
      if self.class.to_s =~ /^Ally::Detector::/
        class_name = self.class.to_s.split('::').last
        if Ally::Settings.settings[:detectors] && Ally::Settings.settings[:detectors][class_name.downcase.to_sym]
          @settings = Ally::Settings.settings[:detectors][class_name.downcase.to_sym]
        end
      end
    end

    def inquiry(inquiry = nil)
      inquiry = Ally::Inquiry.new(inquiry) if inquiry.class == String
      @inquiry = inquiry
      self
    end

    def detected?
      @data_detected == true ? true : false
    end
  end
end
