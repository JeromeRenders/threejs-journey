# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"


export default class extends BaseComponent

    constructor: (@options) ->
                
        # Main light
        @mainLight = @createMainLight()
        @options.scene.add(@mainLight)

        # Secondary light
        @secondaryLight = @createSecondaryLight()
        @options.scene.add(@secondaryLight)

        # Door light
        @doorLight = @createDoorLight()
        @options.scene.add(@doorLight)
        
        # House
        @house = @createHouse()
        @options.scene.add @house

        # Graves
        @graves = @createGraves()
        @options.scene.add @graves

        # Ground
        @ground = @createGround()
        @options.scene.add @ground
    
        @debug()

    debug: ->
        folder = @options.debug.addFolder({ title: "Shadows", expanded: true })

        ambientLight = folder.addFolder({ title: "Ambient light", expanded: false })
        ambientLight.addInput(@mainLight, "intensity", { min: 0, max: 1, step: .01 })

        light = folder.addFolder({ title: "Light", expanded: false })
        light.addInput(@secondaryLight, "intensity", { min: 0, max: 1, step: .01 })
        light.addInput(@secondaryLight.position, "x", { min: -5, max: 15, step: .01 })
        light.addInput(@secondaryLight.position, "y", { min: -5, max: 15, step: .01 })
        light.addInput(@secondaryLight.position, "z", { min: -5, max: 15, step: .01 })


    createHouse: ->
        house = new THREE.Group()
        
        wallsGeometry = new THREE.BoxBufferGeometry(4, 2.5, 4)
        wallsMaterial = new THREE.MeshStandardMaterial({ color: "#ac8e82", shininess: 0, metalness: 0 })
        @walls = new THREE.Mesh(wallsGeometry, wallsMaterial)
        @walls.position.y = 2.5 / 2
        house.add @walls

        roofGeometry = new THREE.ConeBufferGeometry(4, 1, 4)
        roofMaterial = new THREE.MeshStandardMaterial({ color: "#b35f45", shininess: 0, metalness: 0 })
        @roof = new THREE.Mesh(roofGeometry, roofMaterial)
        @roof.position.y = 2.5 + 0.5
        @roof.rotation.y = Math.PI / 4
        house.add @roof

        doorGeometry = new THREE.PlaneBufferGeometry(2, 2)
        doorMaterial = new THREE.MeshStandardMaterial({ color: "#b35f45", shininess: 0, metalness: 0 })
        @door = new THREE.Mesh(doorGeometry, doorMaterial)
        @door.position.y = 2 / 2
        @door.position.z = (4 / 2) + 0.01
        house.add @door

        bushGeometry = new THREE.SphereBufferGeometry(1, 16, 16)
        bushMaterial = new THREE.MeshStandardMaterial({ color: "#89c854", shininess: 0, metalness: 0 })

        @bush1 = new THREE.Mesh(bushGeometry, bushMaterial)
        @bush1.scale.set(.5, .5, .5)
        @bush1.position.set(1.1, .2, 2.2)
        house.add @bush1

        @bush2 = new THREE.Mesh(bushGeometry, bushMaterial)
        @bush2.scale.set(.25, .25, .25)
        @bush2.position.set(1.5, .1, 2.1)
        house.add @bush2

        @bush3 = new THREE.Mesh(bushGeometry, bushMaterial)
        @bush3.scale.set(.4, .4, .4)
        @bush3.position.set(-.8, .1, 2.2)
        house.add @bush3

        @bush4 = new THREE.Mesh(bushGeometry, bushMaterial)
        @bush4.scale.set(.15, .15, .15)
        @bush4.position.set(-1, .05, 2.6)
        house.add @bush4

        return house
        
    createGraves: ->
        graves = new THREE.Group()

        graveGeometry = new THREE.BoxBufferGeometry(.6, .8, .2)
        graveMaterial = new THREE.MeshStandardMaterial({ color: "#b2b6b1" })

        for i in [0...50]
            angle = Math.random() * Math.PI * 2
            radius = 4 + Math.random() * 5
            x = Math.sin(angle) * radius
            z = Math.cos(angle) * radius

            grave = new THREE.Mesh(graveGeometry, graveMaterial)
            grave.position.set(x, .3, z)
            grave.rotation.y = (Math.random() - .5) * .4
            grave.rotation.z = (Math.random() - .5) * .4
            graves.add grave

        return graves

    createGround: ->
        geometry = new THREE.PlaneGeometry(30, 30)
        material = new THREE.MeshStandardMaterial({
            color: "#a9c388"
            shininess: 0
            metalness: 0
        })
        ground = new THREE.Mesh(geometry, material) 

        ground.rotation.x = -Math.PI / 2

        return ground

    createMainLight: ->
        light = new THREE.AmbientLight("#b9d4ff", .12)

        return light
    
    createSecondaryLight: ->
        light = new THREE.DirectionalLight("#b9d4ff", .5)
        light.position.set(4, 5, -2)

        return light

    createDoorLight: ->
        light = new THREE.PointLight("#ff7d46", 1, 7)
        light.position.set(0, 2.2, 2.7)

        return light
