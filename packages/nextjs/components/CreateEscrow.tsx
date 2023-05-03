import React, { useState } from 'react';
import { useScaffoldContractWrite } from "~~/hooks/scaffold-eth";

export const CreateEscrow = () => {
    const [arbiter, setArbiter] = useState('');
    const [beneficiary, setBeneficiary] = useState('');
    const [value, setValue] = useState('');
  
    const { writeAsync, isMining } = useScaffoldContractWrite({
      contractName: "EscrowFactory",
      functionName: "createEscrow",
      args: [arbiter, beneficiary],
      value,
    });
  
    const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
      e.preventDefault();
      await writeAsync();
    };
  
    return (
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          placeholder="Arbiter Address"
          value={arbiter}
          onChange={(e) => setArbiter(e.target.value)}
        />
        <input
          type="text"
          placeholder="Beneficiary Address"
          value={beneficiary}
          onChange={(e) => setBeneficiary(e.target.value)}
        />
        <input
          type="text"
          placeholder="Value (ETH)"
          value={value}
          onChange={(e) => setValue(e.target.value)}
        />
        <button type="submit" disabled={isMining}>
          {isMining ? "Creating Escrow..." : "Create Escrow"}
        </button>
      </form>
    );
  };