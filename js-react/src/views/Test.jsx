import React, { useEffect, useState } from "react";

function Test() {
    const [data, setData] = useState(null);

    // Fetching data when the component mounts
    useEffect(() => {
        const fetchData = async () => {
            try {
                const response = await fetch("http://localhost:8081/test", {
                    headers: {
                        'Authorization': 'Bearer ' + localStorage.getItem('token')
                    }
                });
                const result = await response.json();
                console.log(result);
                setData(result);
            } catch (error) {
                console.error("Error fetching data:", error);
            }
        };
        fetchData();
    }, []);

    return (
        <div>
            <h1>Message from php-symfony service</h1>
            {data ? (
                <div>
                    <h2>{data.message}</h2>
                    <p>{data.path}</p>
                </div>
            ) : (
                <p>Loading...</p>
            )}
        </div>
    );
}

export default Test;