import React from 'react';

export const UserProfileCard = ({ user }) => {
    return (
        <div className="user-card migrated-component">
            <h3>{user.name}</h3>
            <p>Status: {user.isActive ? 'Active' : 'Legacy'}</p>
        </div>
    );
};
