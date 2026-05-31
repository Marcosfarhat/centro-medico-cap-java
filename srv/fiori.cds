using AdminService from './service';

// ESPECIALIDADES
annotate AdminService.Especialidades with @(
    title: 'Especialidad',
    UI.HeaderInfo: {
        TypeName: 'Especialidad',
        TypeNamePlural: 'Especialidades',
        Title: { Value: nombre }
    },
    UI.LineItem: [
        { Value: nombre,      Label: 'Nombre' },
        { Value: descripcion, Label: 'Descripción' }
    ],
    UI.FieldGroup #InfoGeneral: {
        Data: [
            { Value: nombre,      Label: 'Nombre' },
            { Value: descripcion, Label: 'Descripción' }
        ]
    },
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'InfoGeneralFacet',
            Label: 'Información general',
            Target: '@UI.FieldGroup#InfoGeneral'
        }
    ]
);


// MÉDICOS
annotate AdminService.Medicos with @(
    title: 'Médico',
    UI.HeaderInfo: {
        TypeName: 'Médico',
        TypeNamePlural: 'Médicos',
        Title: { Value: apellido },
        Description: { Value: nombre }
    },
    UI.LineItem: [
        { Value: apellido,             Label: 'Apellido' },
        { Value: nombre,               Label: 'Nombre' },
        { Value: matricula,            Label: 'Matrícula' },
        { Value: especialidad.nombre,  Label: 'Especialidad' },
        { Value: email,                Label: 'Email' }
    ],
    UI.FieldGroup #DatosMedico: {
        Data: [
            { Value: nombre,          Label: 'Nombre' },
            { Value: apellido,        Label: 'Apellido' },
            { Value: matricula,       Label: 'Matrícula' },
            { Value: especialidad_ID, Label: 'Especialidad' },
            { Value: email,           Label: 'Email' },
            { Value: telefono,        Label: 'Teléfono' }
        ]
    },
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'DatosMedicoFacet',
            Label: 'Datos del médico',
            Target: '@UI.FieldGroup#DatosMedico'
        }
    ]
);


// PACIENTES
annotate AdminService.Pacientes with @(
    title: 'Paciente',
    UI.HeaderInfo: {
        TypeName: 'Paciente',
        TypeNamePlural: 'Pacientes',
        Title: { Value: apellido },
        Description: { Value: nombre }
    },
    UI.LineItem: [
        { Value: apellido, Label: 'Apellido' },
        { Value: nombre,   Label: 'Nombre' },
        { Value: dni,      Label: 'DNI' },
        { Value: email,    Label: 'Email' },
        { Value: telefono, Label: 'Teléfono' }
    ],
    UI.FieldGroup #DatosPaciente: {
        Data: [
            { Value: nombre,   Label: 'Nombre' },
            { Value: apellido, Label: 'Apellido' },
            { Value: dni,      Label: 'DNI' },
            { Value: email,    Label: 'Email' },
            { Value: telefono, Label: 'Teléfono' }
        ]
    },
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'DatosPacienteFacet',
            Label: 'Datos del paciente',
            Target: '@UI.FieldGroup#DatosPaciente'
        }
    ]
);


// TURNOS
annotate AdminService.Turnos with @(
    title: 'Turno',
    UI.HeaderInfo: {
        TypeName: 'Turno',
        TypeNamePlural: 'Turnos',
        Title: { Value: fecha },
        Description: { Value: estado }
    },
    UI.LineItem: [
        { Value: fecha,             Label: 'Fecha' },
        { Value: hora,              Label: 'Hora' },
        { Value: paciente.apellido, Label: 'Paciente' },
        { Value: medico.apellido,   Label: 'Médico' },
        { Value: estado,            Label: 'Estado' }
    ],
    UI.FieldGroup #DatosTurno: {
        Data: [
            { Value: fecha,       Label: 'Fecha' },
            { Value: hora,        Label: 'Hora' },
            { Value: paciente_ID, Label: 'Paciente' },
            { Value: medico_ID,   Label: 'Médico' },
            { Value: estado,      Label: 'Estado' },
            { Value: notas,       Label: 'Notas' }
        ]
    },
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'DatosTurnoFacet',
            Label: 'Información del turno',
            Target: '@UI.FieldGroup#DatosTurno'
        }
    ]
);