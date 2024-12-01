// EngineDropdown.js
import React from 'react';

const engines = ['standard', 'neural' , 'long-form' , 'generative'];  // Polly engines

const EngineDropdown = ({ selected, onChange }) => {
    return (
        <select value={selected} onChange={(e) => onChange(e.target.value)}>
            {engines.map((engine) => (
                <option key={engine} value={engine}>
                    {engine}
                </option>
            ))}
        </select>
    );
};

export default EngineDropdown;