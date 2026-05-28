using { com.centromedico as cm } from '../db/schema';

// ═══════════════════════════════════════════════════════════════════
// SERVICIO ADMINISTRATIVO
// Acceso total a todas las entidades. Para usuarios "admin".
//
// URL base: /odata/v4/AdminService/
// ═══════════════════════════════════════════════════════════════════
service AdminService {

    entity Pacientes      as projection on cm.Pacientes;
    entity Medicos        as projection on cm.Medicos;
    entity Especialidades as projection on cm.Especialidades;
    entity Turnos         as projection on cm.Turnos;

}