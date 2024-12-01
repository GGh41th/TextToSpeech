import React, { useState, useEffect } from 'react';
import AWS from 'aws-sdk';

const REGION = "eu-west-3";

AWS.config.update({
    region: REGION,
    credentials: new AWS.CognitoIdentityCredentials({
      IdentityPoolId: "eu-west-3:0b032d28-f5c6-404f-bb93-9bd1b23ec2c8", 
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
