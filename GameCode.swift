import Foundation

/*
The setup() function is called once when the app launches. Without it, your app won't compile.
Use it to set up and start your app.

You can create as many other functions as you want, and declare variables and constants,
at the top level of the file (outside any function). You can't write any other kind of code,
for example if statements and for loops, at the top level; they have to be written inside
of a function.
*/
let ball = OvalShape(width: 40, height: 40)
var barriers: [Shape] = []


let funnelPoints = [Point(x: 0, y: 50), Point(x: 80, y: 50), Point(x: 60, y: 0), Point(x: 20, y: 0)]
let funnel = PolygonShape(points: funnelPoints)

let targetPoints = [Point(x: 10, y: 0), Point(x: 0, y: 10), Point(x: 10, y: 20), Point(x: 20, y: 10)]
let target = PolygonShape(points: targetPoints)

fileprivate func setupBall() {
    ball.position = Point(x: 250, y: 400)
    scene.add(ball)
    ball.hasPhysics = true
    ball.fillColor = .blue
    ball.onCollision = ballCollided(with:)
    ball.isDraggable = false
    scene.trackShape(ball)
    ball.onExitedScene = ballExitedScene
    ball.onTapped = resetGame
    ball.bounciness = 0.6
}

fileprivate func addBarrier(at position: Point, width: Double, height: Double, angle: Double) {
    let barrierPoints = [Point(x: 0, y: 0), Point(x: 0, y: height), Point(x: width, y: height), Point(x: width, y: 0)]
    let barrier = PolygonShape(points: barrierPoints)
    barriers.append(barrier)
    barrier.position = position
    barrier.hasPhysics = true
    scene.add(barrier)
    barrier.isImmobile = true
    barrier.angle = angle
}

fileprivate func setupFunnel() {
    funnel.position = Point(x: 200, y: scene.height - 25)
    scene.add(funnel)
    funnel.onTapped = dropBall
    funnel.fillColor = .gray
}

func setupTarget() {
    target.position = Point(x: 200, y: 400)
    target.hasPhysics = true
    target.isImmobile = true
    target.isImpermeable = true
    target.fillColor = .yellow
    scene.add(target)
    target.name = "target"
    
}


func ballCollided(with otherShape: Shape) {
    if otherShape.name != "target" {
        return
    }
    otherShape.fillColor = .green
}

func ballExitedScene() {
    for barrier in barriers {
        barrier.isDraggable = true
    }
    
}

func resetGame() {
    ball.position = Point(x: 0, y: -80)
}

func setup() {
    setupBall()

    addBarrier(at: Point(x: 200, y: 150), width: 80, height: 25, angle: 0.2)

    setupFunnel()
    
    setupTarget()
    
    resetGame()
}

func dropBall() {
    ball.position = funnel.position
    ball.stopAllMotion()
    for barrier in barriers {
        barrier.isDraggable = false
    }
}
