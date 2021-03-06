# frozen_string_literal: true

module BoomerBot
  # Image to be posted when a boomer heresy should be punished by the law
  class Image
    # @return [Array<String (frozen)>, String (frozen)]
    def self.introduction_image
      %w[
        https://i.imgur.com/mllwVTT.gif
        https://i.imgur.com/vRRzfwB.png
        https://i.imgur.com/dtjDrD8.png
        https://i.imgur.com/mYQBAro.png
        https://i.imgur.com/F4Acprg.png
      ].sample
    end

    # @return [Array<String (frozen)>, String (frozen)]
    def self.already_a_boomer_image
      %w[
        https://i.imgur.com/suBmBZ9.png https://i.imgur.com/wRuR5Fr.png
        https://i.imgur.com/kJ59ceu.png https://i.imgur.com/CVkOwko.gif
        https://i.imgur.com/MPw3EYt.png https://i.imgur.com/9Y9oW3G.png
        https://i.imgur.com/kt9H1mE.png https://i.imgur.com/kFp4zTY.png
        https://i.imgur.com/pdCJdTj.png https://i.imgur.com/10oHAvw.jpg
        https://i.imgur.com/usQD7FK.png https://i.imgur.com/1Bn3PAE.png
        https://i.imgur.com/T3AbKRR.png https://i.imgur.com/VbrweID.jpg
        https://i.imgur.com/ZgEbCq2.jpg https://i.imgur.com/SCMkChc.jpg
      ].sample
    end
  end
end
