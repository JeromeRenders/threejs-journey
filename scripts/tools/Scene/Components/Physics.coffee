# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"
import CANNON        from "cannon"

import BaseComponent from "./BaseComponent.coffee"


export default class extends BaseComponent

    constructor: (@options) ->

        @oldElapsedTime = 0

        @world = new CANNON.World()
        @world.gravity.set(0, -9.82, 0)

        @defaultMaterial = new CANNON.Material("default")

        @defaultContactMaterial = new CANNON.ContactMaterial(@defaultMaterial, @defaultMaterial, {
            friction: .1
            restitution: .9
        })
        @world.addContactMaterial(@defaultContactMaterial)

        @createSphere()
        @createFloor()
        @createLights()

        @debug()

        # tuto time 53:45


    # ==================================================
    # > CREATE START
    # ==================================================
    createSphere: ->

        # CANNON.JS
        sphereShape = new CANNON.Sphere(.5)
        @sphereBody = new CANNON.Body({
            mass:     1
            position: new CANNON.Vec3(0, 3, 0)
            shape:    sphereShape
            material: @defaultMaterial
        })
        @sphereBody.applyLocalForce(new CANNON.Vec3(150, 0, 0), new CANNON.Vec3(0, 0, 0))
        @world.addBody(@sphereBody)

        # THREE.JS
        @sphere = new THREE.Mesh(
            new THREE.SphereGeometry(.5, 32, 32)
            new THREE.MeshStandardMaterial({
                metalness: .3
                roughness: .4
            })
        )
        @sphere.castShadow = true
        @sphere.position.y = .5
        @options.scene.add(@sphere)

    createFloor: ->

        # CANNON.JS
        floorShape = new CANNON.Plane()
        @floorBody = new CANNON.Body({
            mass: 0
            shape: floorShape
            material: @defaultMaterial
        })
        @floorBody.quaternion.setFromAxisAngle(new CANNON.Vec3(-1, 0, 0), Math.PI * .5)
        @world.addBody(@floorBody)

        # THREE.JS
        @floor = new THREE.Mesh(
            new THREE.PlaneGeometry(10, 10)
            new THREE.MeshStandardMaterial({
                color: "#777777"
                metalness: .3
                roughness: .4
            })
        )
        @floor.receiveShadow = true
        @floor.rotation.x = -Math.PI * .5
        @options.scene.add(@floor)

    createLights: ->
        ambientLight = new THREE.AmbientLight(0xffffff, .7)
        @options.scene.add(ambientLight)

        directionalLight = new THREE.DirectionalLight(0xffffff, .2)
        directionalLight.castShadow = true
        directionalLight.shadow.mapSize.set(1024, 1024)
        directionalLight.shadow.camera.far = 15
        directionalLight.shadow.camera.left = -7
        directionalLight.shadow.camera.top = 7
        directionalLight.shadow.camera.right = 7
        directionalLight.shadow.camera.bottom = -7
        directionalLight.position.set(5, 5, 5)
        @options.scene.add(directionalLight)


    # ==================================================
    # > EVENTS
    # ==================================================
    onUpdate: (elapsedTime) ->

        # Get the delta of time passed between last elapsed time
        deltaTime = elapsedTime - @oldElapsedTime
        @oldElapsedTime = elapsedTime

        # Wind
        @sphereBody.applyForce(new CANNON.Vec3(-.5, 0, 0), @sphereBody.position)

        # Update the Cannon.js world
        @world.step(1 / 60, deltaTime, 3)

        # Update the Three.js components from the Cannon.js world
        @sphere.position.copy(@sphereBody.position)