import { useWriteContract } from "wagmi";
import { useState } from "react";
import { CONTRACTS } from "../../../vehicular-dapp/src/contracts";
import VehicleDocumentsABI from "../abi/VehicleDocuments.json";

export default function Documentos() {
  const { writeContract } = useWriteContract();

  const [vehicleId, setVehicleId] = useState("");
  const [hash, setHash] = useState("");
  const [expiry, setExpiry] = useState("");
  const [tipo, setTipo] = useState("permiso");

  function emitir() {
    const functionMap = {
      permiso: "setPermisoCirculacion",
      seguro: "setSeguro",
      revision: "setRevisionTecnica",
      emisiones: "setEmisiones",
    };

    writeContract({
      address: CONTRACTS.VehicleDocuments,
      abi: VehicleDocumentsABI,
      functionName: functionMap[tipo],
      args: [
        Number(vehicleId),
        hash,
        Number(expiry),
        true
      ],
    });
  }

  return (
    <div>
      <h2 className="text-xl mb-4">Emitir Documentos</h2>

      <input
        placeholder="ID del vehículo"
        className="input"
        onChange={e => setVehicleId(e.target.value)}
      />

      <input
        placeholder="Hash del documento"
        className="input"
        onChange={e => setHash(e.target.value)}
      />

      <input
        placeholder="Fecha expiración (timestamp)"
        type="number"
        className="input"
        onChange={e => setExpiry(e.target.value)}
      />

      <select className="input" onChange={e => setTipo(e.target.value)}>
        <option value="permiso">Permiso de circulación (Municipalidad)</option>
        <option value="seguro">Seguro SOAP (Aseguradora)</option>
        <option value="revision">Revisión Técnica</option>
        <option value="emisiones">Emisiones</option>
      </select>

      <button
        onClick={emitir}
        className="px-4 py-2 bg-blue-500 text-white rounded mt-4"
      >
        Emitir Documento
      </button>
    </div>
  );
}
