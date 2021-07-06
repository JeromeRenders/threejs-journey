import $             from "jquery"
import gsap          from "gsap"
import ScrollTrigger from "gsap/ScrollTrigger"

gsap.registerPlugin(ScrollTrigger)


export default init: ->


    # gsap.to($(".archive--thumbs .archive__item"), {
    #     x: -1 * ($(".archive--thumbs .archive__list").width() - $(".archive--thumbs").width())
    #     duration: 0.4
    #     scrollTrigger: {
    #         trigger: $(".archive--thumbs")
    #         scrub: true
    #     }
    # })
