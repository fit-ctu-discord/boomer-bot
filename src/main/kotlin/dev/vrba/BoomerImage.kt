package dev.vrba

object BoomerImage
{
    private val introductionImages = listOf(
        "https://i.imgur.com/mllwVTT.gif",
        "https://i.imgur.com/vRRzfwB.png",
        "https://i.imgur.com/dtjDrD8.png",
        "https://i.imgur.com/mYQBAro.png",
	"https://i.imgur.com/F4Acprg.png"
    )
    
    private val repeatedBoomerPostingImages = listOf(
        "https://i.imgur.com/suBmBZ9.png",
        "https://i.imgur.com/wRuR5Fr.png",
        "https://i.imgur.com/kJ59ceu.png",
        "https://i.imgur.com/CVkOwko.gif",
        "https://i.imgur.com/MPw3EYt.png",
        "https://i.imgur.com/9Y9oW3G.png",
        "https://i.imgur.com/kt9H1mE.png",
        "https://i.imgur.com/kFp4zTY.png",
        "https://i.imgur.com/pdCJdTj.png",
        "https://i.imgur.com/10oHAvw.jpg",
	"https://i.imgur.com/usQD7FK.png",
	"https://i.imgur.com/T3AbKRR.png"
    )
    
    val forIntroduction: String
    get() = this.introductionImages.random()
    
    val forRepeatedBoomerPosting: String
    get() = this.repeatedBoomerPostingImages.random()
}
