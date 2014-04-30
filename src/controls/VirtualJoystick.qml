import QtQuick 2.0
import Machinekit.Controls 1.0

/*!
    \qmltype VirtualJoystick
    \inqmlmodule Machinekit.Controls
    \brief A virtual joystick control.
    \ingroup machinekitcontrols

    The virtual joystick provides a to simulate a joystick-like control
    for touchscreen displays.

    The controls has two output values called \l xValue and \l{yValue}.
    The possible output values are - \l maximumValue to \l maximumValue whereas
    0 is the value in the center of the joystick.

    \qml
    VirtualJoystick {
        id: virtualJoystick
    }
    \endqml
*/

Rectangle {

    /*! This property holds the maximum alowed value in x and y direction.
        The output value is in the range of  - \c maximumValue to \c{maximumValue}.

        The default value is \c{100}.
    */
    property double maximumValue: 100.0

    /*! This property holds the output value step size.

      The default value is \c{1}.
    */
    property double stepSize: 1.0

    /*! This property holds wheter the joystick should be automacially fall back
        to the center position or not.

        The default value is \c{true}.
    */
    property bool autoCenter: true

    /*! This property holds joystick position in x direction
    */
    readonly property double xValue: 0

    /*! This property holds joystick position in y direction
    */
    readonly property double yValue: 0

    /*! \internal */
    function centeredX()
    {
        return main.width/2 - control.width/2
    }

    /*! \internal */
    function centeredY()
    {
        return main.height/2 - control.height/2
    }

    /*! \internal */
    function maxX()
    {
        //var maxRadius = main.width/2

        //return Math.sqrt(Math.pow(maxRadius, 2)-Math.pow(y, 2))
        return main.width - control.width
    }

    /*! \internal */
    function maxY()
    {
        return main.height - control.height
    }

    /*! \internal */
    function maxControlX()
    {
        return control.width/2 - main.width/2
    }

    /*! \internal */
    function maxControlY()
    {
        return control.height/2 - main.height/2
    }

    /*! \internal */
    function calculateNewX()
    {
        var newControlX = 0

        newControlX = controlArea.mouseX - control.width/2
        if (newControlX > maxX())
        {
            newControlX = maxX()
        }
        else if (newControlX < 0)
        {
            newControlX = 0
        }

        control.x = newControlX
    }

    /*! \internal */
    function calculateNewY()
    {
        var newControlY = 0

        newControlY = controlArea.mouseY - control.height/2
        if (newControlY > maxY())
        {
            newControlY = maxY()
        }
        else if (newControlY < 0)
        {
            newControlY = 0
        }

        control.y = newControlY
    }

    id: main

    width: 150; height: 150
    color: "#00000000"

    Binding { target: main; property: "xValue"; value: (Math.floor(((control.x + maxControlX()) / Math.abs(maxControlX()) * maximumValue) / stepSize) * stepSize)}
    //Binding { target: control; property: "x"; value: Math.pow(main.xVelocity/stepSize,2) * stepSize / maxVelocity * Math.abs(maxControlX()) - maxControlX()}

    Binding { target: main; property: "yValue"; value: (Math.floor(((control.y + maxControlY()) / Math.abs(maxControlY()) * maximumValue) / stepSize) * stepSize)}

    SystemPalette {
        id: systemPalette;
        colorGroup: enabled ? SystemPalette.Active : SystemPalette.Disabled
    }

    Rectangle {
        id: circle1

        width: parent.width; height: parent.height
        anchors.centerIn: parent
        radius: width / 2
        clip: true
        color: systemPalette.highlight

        Rectangle {
            id: circle2

            width: main.width * 0.8; height: main.width * 0.8
            anchors.centerIn: parent
            radius: width / 2
            clip: true
            color: systemPalette.window

            Rectangle {
                id: circle3

                width: main.width * 0.6; height: main.width * 0.6
                anchors.centerIn: parent
                radius: width / 2
                clip: true
                color: systemPalette.highlight
            }
        }
    }

    Rectangle {
        id: control

        property bool movable: false

        width: main.width * 0.3; height: main.width * 0.3
        x: centeredX(); y: centeredY(); z: 1
        radius: width / 2
        clip: true
        color: {
            if (!movable)
                systemPalette.dark
            else
                systemPalette.midlight
        }


    }

    MouseArea {
        id: controlArea

        anchors.fill: parent

        onPressed: control.movable = true
        onReleased: {
            control.movable = false
            if (main.autoCenter)
            {
                control.x = centeredX()
                control.y = centeredY()
            }
        }
        onMouseXChanged: {
            if (control.movable)
            {
                calculateNewX()
            }
        }
        onMouseYChanged: {
            if (control.movable)
            {
                calculateNewY()
            }
        }
    }

    Line {
        id: line

        x1: main.width/2; y1: main.height/2
        x2: control.x + control.width/2; y2: control.y + control.height/2
        lineWidth: 14
        color: systemPalette.dark
    }

    /*onYVelocityChanged: {
        console.log("Y:")
        console.log(yVelocity)
    }

    onXVelocityChanged: {
        console.log("X:")
        console.log(xVelocity)
    }*/
}