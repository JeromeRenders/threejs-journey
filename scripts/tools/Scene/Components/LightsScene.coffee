# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"


export default class extends BaseComponent

    constructor: (@options) ->
        
        @main = new THREE.AmbientLight(0xffffff, .5)
        @options.scene.add(@main)

        @point = new THREE.PointLight(0xffffff, .5)
        @point.position.set(2, 5, 5)
        @options.scene.add(@point)


        @material = new THREE.MeshStandardMaterial()
        
        objectGeometry = new THREE.SphereBufferGeometry(1, 32, 32)
        @object = new THREE.Mesh(objectGeometry, @material)
        @options.scene.add @object

        planeGeometry = new THREE.PlaneBufferGeometry(8, 8)
        @plane = new THREE.Mesh(planeGeometry, @material)
        @plane.position.y = -2
        @plane.rotation.x = -Math.PI * .5
        @options.scene.add @plane


