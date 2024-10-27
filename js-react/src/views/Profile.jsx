import React, {Component} from 'react';

class Profile extends Component {
    render() {
        const { given_name, family_name, picture } = this.props.tokenParsed;
        return (
            <div>
                <h2>Profile</h2>
                <p>Hello {given_name} {family_name}</p>

                <img src={picture} alt=""/>
            </div>
        )
    }
}

export default Profile;