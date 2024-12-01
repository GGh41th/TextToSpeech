// LanguageDropdown.js
import React from 'react';

const languages = [
    { code: 'en-US', name: 'US English' },
    { code: 'en-GB', name: 'British English' },
    { code: 'es-ES', name: 'Spanish' },
    { code: 'fr-FR', name: 'French' },
    { code: 'de-DE', name: 'German' },
    { code: 'it-IT', name: 'Italian' },
    // Add more languages as needed
];

const LanguageDropdown = ({ selected, onChange }) => {
    return (
        <select value={selected} onChange={(e) => onChange(e.target.value)}>
            {languages.map((lang) => (
                <option key={lang.code} value={lang.code}>
                    {lang.name}
                </option>
            ))}
        </select>
    );
};

export default LanguageDropdown;