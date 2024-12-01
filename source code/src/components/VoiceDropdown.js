import React, { useState, useEffect } from 'react';
import AWS from 'aws-sdk';

// Change the region accordingly , and keep in mind that some regions doesn't support all engines , consult the documentation.
const REGION = "eu-west-3";

AWS.config.update({
    region: REGION,
    credentials: new AWS.CognitoIdentityCredentials({
      IdentityPoolId: process.env.COGNITO_ID_POOL, 
    }),
  });

const polly = new AWS.Polly();

const VoiceDropdown = ({ selectedLanguage, selectedEngine, selected, onChange }) => {
    const [voices, setVoices] = useState([]);

    useEffect(() => {
        const fetchVoices = async () => {
            try {
                const data = await polly
                    .describeVoices({ LanguageCode: selectedLanguage })
                    .promise();
                
                // Filter voices by engine
                const filteredVoices = data.Voices.filter((voice) =>
                    voice.SupportedEngines.includes(selectedEngine)
                );

                setVoices(filteredVoices);
            } catch (error) {
                console.error('Error fetching voices:', error);
            }
        };

        fetchVoices(); // Fetch voices when language or engine changes
    }, [selectedLanguage, selectedEngine]);

    return (
        <select value={selected} onChange={(e) => onChange(e.target.value)}>
            <option value="">Select a voice</option> {/* Added a default option */}
            {voices.map((voice) => (
                <option key={voice.Id} value={voice.Id}>
                    {voice.Name} ({voice.Gender})
                </option>
            ))}
        </select>
    );
};

export default VoiceDropdown;
