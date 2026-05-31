sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"adminturnosui/test/integration/pages/TurnosList",
	"adminturnosui/test/integration/pages/TurnosObjectPage"
], function (JourneyRunner, TurnosList, TurnosObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('adminturnosui') + '/test/flpSandbox.html#adminturnosui-tile',
        pages: {
			onTheTurnosList: TurnosList,
			onTheTurnosObjectPage: TurnosObjectPage
        },
        async: true
    });

    return runner;
});

