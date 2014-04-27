module Ally
  module Detector
    attr_accessor :inquiry, :data_detected, :settings, :datapoints

    def initialize(inquiry = nil)
      inquiry(inquiry)
      @datapoints = []
      @data_detected = false
      @settings = nil
      @settings = Ally::Foundation.get_plugin_settings(self.class.to_s, 'detectors')
    end

    def inquiry(inquiry = nil)
      @inquiry = Ally::Inquiry.new(inquiry) if inquiry.class == String
      self
    end

    def detected?
      @data_detected == true ? true : false
    end
  end
end
