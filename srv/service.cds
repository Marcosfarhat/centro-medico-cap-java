using { com.centromedico as cm } from '../db/schema';

// SERVICIO ADMINISTRATIVO
// Acceso total a todas las entidades.
// URL base: /odata/v4/AdminService/
@path: 'AdminService'
@requires: 'admin'
service AdminService {
    @odata.draft.enabled
    entity Pacientes      as projection on cm.Pacientes;
    @odata.draft.enabled
    entity Medicos        as projection on cm.Medicos;
    @odata.draft.enabled
    entity Especialidades as projection on cm.Especialidades;
    @odata.draft.enabled
    entity Turnos         as projection on cm.Turnos;
}