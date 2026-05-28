namespace com.centromedico;

using { cuid, managed } from '@sap/cds/common';

// ═══════════════════════════════════════════════════════════════════
// ENTIDAD: Especialidades
// Categorías médicas (Cardiología, Pediatría, etc.)
// ═══════════════════════════════════════════════════════════════════
entity Especialidades : cuid {
    nombre       : String(100) not null;
    descripcion  : String(500);

    // Relación inversa: una especialidad tiene muchos médicos
    medicos      : Association to many Medicos
                       on medicos.especialidad = $self;
}


// ═══════════════════════════════════════════════════════════════════
// ENTIDAD: Medicos
// Profesionales que atienden en el centro médico
// ═══════════════════════════════════════════════════════════════════
entity Medicos : cuid, managed {
    nombre        : String(100) not null;
    apellido      : String(100) not null;
    matricula     : String(20);
    email         : String(120);
    telefono      : String(30);

    // FK hacia Especialidades (genera columna ESPECIALIDAD_ID)
    especialidad  : Association to Especialidades;

    // Relación inversa: un médico tiene muchos turnos
    turnos        : Association to many Turnos
                        on turnos.medico = $self;
}


// ═══════════════════════════════════════════════════════════════════
// ENTIDAD: Pacientes
// Personas que toman turnos
// ═══════════════════════════════════════════════════════════════════
entity Pacientes : cuid, managed {
    nombre    : String(100) not null;
    apellido  : String(100) not null;
    email     : String(120) not null;
    telefono  : String(30);
    dni       : String(20);

    // Relación inversa: un paciente tiene muchos turnos
    turnos    : Association to many Turnos
                    on turnos.paciente = $self;
}


// ═══════════════════════════════════════════════════════════════════
// ENTIDAD: Turnos
// Cita médica con paciente, médico, fecha y estado
// ═══════════════════════════════════════════════════════════════════
entity Turnos : cuid, managed {
    fecha     : Date not null;
    hora      : Time not null;
    estado    : String(20) default 'PROGRAMADO';
    notas     : String(500);

    // FK hacia Pacientes (genera columna PACIENTE_ID)
    paciente  : Association to Pacientes;

    // FK hacia Medicos (genera columna MEDICO_ID)
    medico    : Association to Medicos;
}