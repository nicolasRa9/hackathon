import { useReadContract } from "wagmi";
import { useState } from "react";
import { CONTRACTS } from "../../../vehicular-dapp/src/contracts";
import VehicleDocumentsABI from "../abi/VehicleDocuments.json";

export default function Consulta() {
  const [vehicleId, setVehicleId] = useState("");

  const { data, refetch } = useReadContract({
    address: CONTRACTS.VehicleDocuments,
    abi: [
      {
        "inputs": [{ "internalType": "uint256", "name": "vehicleId", "type": "uint256" }],
        "name": "getAllDocs",
        "outputs": [
          {
            "components": [
              { "internalType": "bytes32", "name": "docHash", "type": "bytes32" },
              { "internalType": "uint64", "name": "expiry", "type": "uint64" },
              { "internalType": "bool", "name": "valid", "type": "bool" }
            ],
            "internalType": "struct VehicleDocuments.VehicleDocs",
            "name": "",
            "type": "tuple"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      }
    ],
    functionName: "getAllDocs",
    args: [Number(vehicleId) || 0],
    enabled: false,
  });

  return (
    <div>
      <h2 className="text-xl mb-4">Consultar Documentos</h2>

      <input
        className="input"
        placeholder="ID del vehículo"
        onChange={e => setVehicleId(e.target.value)}
      />

      <button
        onClick={() => refetch()}
        className="px-4 py-2 bg-blue-500 text-white rounded mt-2"
      >
        Consultar
      </button>

      {data && (
        <div className="mt-4 p-4 border rounded">
          <h3 className="font-bold">Información del vehículo</h3>
          <pre className="mt-2">
            {JSON.stringify(data, null, 2)}
          </pre>
        </div>
      )}
    </div>
  );
}
