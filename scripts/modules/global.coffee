import $                from "jquery"
import gsap             from "gsap"
import LocomotiveScroll from "locomotive-scroll"

import SceneManager     from "../tools/Scene/SceneManager.coffee"
import ScrollAnimations from "../tools/ScrollAnimations.coffee"

$ ->

    # ==================================================
    # > CUSTOM SCROLL (LOCOMOTIVE)
    # ==================================================
    scroller = new LocomotiveScroll({
        el:           document.querySelector(".site")
        smooth:       true
        smoothMobile: true
        getSpeed:     true
        getDirection: true
    })

    # ==================================================
    # > SCROLL ANIMATIONS (GSAP)
    # ==================================================
    ScrollAnimations.init()


    # ==================================================
    # > THREEJS SCENE
    # ==================================================
    scene = new SceneManager({
        container: document.querySelector("body")
        debug:     true
        controls:  true
        stats:     true
        composer:  false
        scroller:  scroller
    })



    # ==================================================
    # > Custom mouse
    # ==================================================
    # $(window).on "mousemove", (e) ->
    #     gsap.to $(".site-cursor--point"), .3, {
    #         left: e.clientX
    #         top: e.clientY
    #         ease: "Power4.easeOut"
    #     }
    #     gsap.to $(".site-cursor--circle"), .6, {
    #         left: e.clientX
    #         top: e.clientY
    #         ease: "Power4.easeOut"
    #     }